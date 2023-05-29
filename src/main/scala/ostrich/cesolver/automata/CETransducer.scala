package ostrich.cesolver.automata
import scala.collection.mutable.{
  HashMap => MHashMap,
  HashSet => MHashSet,
  Stack => MStack,
  MultiMap => MMultiMap,
  Set => MSet,
  LinkedHashSet => MLinkedHashSet
}
import ostrich.automata.TLabelOps
import ostrich.automata.BricsTLabelOps
import ostrich.automata.Transducer._

object CETransducer {
  type State = CostEnrichedAutomatonBase#State
  type TLabel = CostEnrichedAutomatonBase#TLabel

  private val strAtRightTransducer =
    new MHashMap[Int, CETransducer]

  /**
   * Transducer that eats every input and produces no output.
   */
  lazy val SilentTransducer : CETransducer = {
    

    val ceTran = new CETransducer

    ceTran.setAccept(ceTran.initialState, true)

    ceTran.addTransition(ceTran.initialState,
                          ceTran.LabelOps.sigmaLabel,
                          OutputOp("", NOP, ""),
                          ceTran.initialState)

    ceTran
  }


   /**
   * Construct a transducer that extracts the <code>n</code>th-last character
   * of a string.
   */
  def getStrAtRightTransducer(n : Int) : CETransducer =
    synchronized {
      strAtRightTransducer.getOrElseUpdate(
        n, 
        if (n < 0) {
          SilentTransducer
        } else {
          

          val ceTran = new CETransducer

          val initState      = ceTran.initialState
          val repeatState    = ceTran.newState()
          val tailStates     = for (i <- 0 to n)    yield ceTran.newState()
          val shortStrStates = for (i <- 1 until n) yield ceTran.newState()

          for (Seq(s1, s2) <- (tailStates sliding 2) ++
                              ((List(initState) ++ shortStrStates) sliding 2) ++
                              Iterator(List(repeatState, repeatState),
                                       List(initState, repeatState)))
            ceTran.addTransition(s1,
                                  ceTran.LabelOps.sigmaLabel,
                                  OutputOp("", NOP, ""),
                                  s2)

          ceTran.addTransition(initState,
                                ceTran.LabelOps.sigmaLabel,
                                OutputOp("", Plus(0), ""),
                                tailStates.head)
          ceTran.addTransition(repeatState,
                                ceTran.LabelOps.sigmaLabel,
                                OutputOp("", Plus(0), ""),
                                tailStates.head)

          ceTran.setAccept(initState, true)
          ceTran.setAccept(tailStates.last, true)

          for (s <- shortStrStates)
            ceTran.setAccept(s, true)

          ceTran
        })
    }

}

class CETransducer {
  import CETransducer._
  

  type TTransition = (TLabel, OutputOp, State)
  type TETransition = (OutputOp, State)

  private var stateidx = 0
  private var _initialState: State = newState()
  private val _lblTrans: MHashMap[State, MHashSet[TTransition]] = MHashMap()
  private val _eTrans: MHashMap[State, MHashSet[TETransition]] = MHashMap()
  private val _acceptingStates: MHashSet[State] = MHashSet()

  private def label(t: TTransition) = t._1
  private def operation(t: TTransition) = t._2
  private def dest(t: TTransition): State = t._3
  private def operation(t: TETransition) = t._1
  private def dest(t: TETransition): State = t._2
  private def dest(t: Either[TTransition, TETransition]): State = t match {
    case Left(lblTran) => dest(lblTran)
    case Right(eTran)  => dest(eTran)
  }

  val LabelOps: TLabelOps[TLabel] = BricsTLabelOps

  def isAccept(s: State) = _acceptingStates.contains(s)

  def preImage(aut : CostEnrichedAutomatonBase) : CostEnrichedAutomatonBase =
    preImage(aut, Iterable())

  def preImage(
      aut: CostEnrichedAutomatonBase,
      internals: Iterable[(State, State, Seq[Int])] = Iterable()
  ): CostEnrichedAutomatonBase =
    /* Exploration.measure("transducer pre-op") */ {

      val ceAut = new CostEnrichedAutomatonBase
      ceAut.registers = aut.registers
      ceAut.regsRelation = aut.regsRelation

      val emptyVec = Seq.fill(aut.registers.size)(0)
      val epsilonPairs = new MHashSet[(State, State, Seq[Int])]

      val internalMap =
        new MHashMap[State, MSet[(State, Seq[Int])]]
          with MMultiMap[State, (State, Seq[Int])] {
          override def default(q: State): MSet[(State, Seq[Int])] =
            MLinkedHashSet()
        }

      for ((s1, s2, vec) <- internals)
        internalMap.addBinding(
          s1.asInstanceOf[State],
          (s2.asInstanceOf[State], vec)
        )

      // map states of pre-image aut to state of transducer and state of
      // aut
      val sMap = new MHashMap[State, (State, State)]
      val sMapRev = new MHashMap[(State, State), State]

      val initAutState = aut.initialState
      val newInitState = ceAut.initialState

      sMap += (newInitState -> ((_initialState, initAutState)))
      sMapRev += (_initialState, initAutState) -> newInitState

      // collect silent transitions during main loop and eliminate them
      // after (TODO: think of more efficient solution)
      val silentTransitions = new MHashMap[State, MSet[State]]
        with MMultiMap[State, State]

      def sumVec(v1: Seq[Int], v2: Seq[Int]) =
        (v1 zip v2).map { case (x, y) => x + y }

      // transducer state, automaton state
      def getState(ts: State, as: State) = {
        sMapRev.getOrElse(
          (ts, as), {
            val ps = ceAut.newState()
            sMapRev += ((ts, as) -> ps)
            sMap += (ps -> (ts, as))
            ps
          }
        )
      }

      // when working through a transition ..
      abstract class Mode
      // .. either doing pre part (u remains to do)
      case class Pre(u: Seq[Char]) extends Mode
      // .. applying operation
      case object Op extends Mode
      // .. or working through post part, once done any new transition
      // added to pre-image aut should have label lbl
      case class Post(u: Seq[Char], lbl: aut.TLabel) extends Mode
      // post part for adding etran
      case class EPost(u: Seq[Char]) extends Mode

      // (ps, ts, t, as, v, m)
      // state of pre aut to add new transitions from
      // current state of transducer reached
      // transition being processed
      // current state of target aut reached
      // mode as above
      val worklist = new MStack[
        (
            State,
            State,
            Either[TTransition, TETransition],
            State,
            Seq[Int],
            Mode
        )
      ]
      val seenlist = new MHashSet[
        (
            State,
            State,
            Either[TTransition, TETransition],
            State,
            Seq[Int],
            Mode
        )
      ]

      def addWork(
          ps: State,
          ts: State,
          t: Either[TTransition, TETransition],
          as: State,
          vec: Seq[Int],
          m: Mode
      ) {
        if (!seenlist.contains((ps, ts, t, as, vec, m))) {
          seenlist += ((ps, ts, t, as, vec, m))
          worklist.push((ps, ts, t, as, vec, m))
        }
      }

      def reachStates(ts: State, as: State) {
        val ps = getState(ts, as)
        if (isAccept(ts) && aut.isAccept(as))
          ceAut.setAccept(ps, true)

        for (trans <- _lblTrans.get(ts); t <- trans) {
          val tOp = operation(t)
          if (tOp.preW.isEmpty)
            addWork(ps, ts, Left(t), as, emptyVec, Op)
          else
            addWork(ps, ts, Left(t), as, emptyVec, Pre(tOp.preW))
        }

        for (trans <- _eTrans.get(ts); t <- trans) {
          val tOp = operation(t)
          if (tOp.preW.isEmpty)
            addWork(ps, ts, Right(t), as, emptyVec, Op)
          else
            addWork(ps, ts, Right(t), as, emptyVec, Pre(tOp.preW))
        }
      }

      reachStates(_initialState, aut.initialState)

      while (!worklist.isEmpty) {
        // pre aut state, transducer state, automaton state
        val (ps, ts, t, as, vec, m) = worklist.pop()

        m match {
          case Pre(u) if u.isEmpty => {
            // should never happen
            throw new Exception(
              "When computing pre-image of CETransducer: should never happen"
            )
          }
          case Pre(u) if !u.isEmpty => {
            val a = u.head
            val rest = u.tail
            for ((asNext, albl, asVec) <- aut.outgoingTransitionsWithVec(as)) {
              if (aut.LabelOps.labelContains(a, albl)) {
                if (!rest.isEmpty) {
                  addWork(ps, ts, t, asNext, sumVec(vec, asVec), Pre(rest))
                } else {
                  addWork(ps, ts, t, asNext, sumVec(vec, asVec), Op)
                }
              }
            }
          }
          case Op => {
            t match {
              case Left(lblTran) => {
                val tOp = operation(lblTran)
                val (min, max) = label(lblTran)
                val tlbl = aut.LabelOps.interval(min, max)
                tOp.op match {
                  case NOP => {
                    addWork(ps, ts, t, as, vec, Post(tOp.postW, tlbl))
                  }
                  case Internal => {
                    for ((asNext, asVec) <- internalMap(as))
                      addWork(ps, ts, t, asNext, sumVec(vec, asVec), Post(tOp.postW, tlbl))
                  }
                  case Plus(n) => {
                    for (
                      (asNext, albl, asVec) <- aut.outgoingTransitionsWithVec(
                        as
                      )
                    ) {
                      val shftLbl = aut.LabelOps.shift(albl, -n)
                      if (aut.LabelOps.isNonEmptyLabel(shftLbl)) {
                        for (
                          preLbl <- aut.LabelOps.intersectLabels(shftLbl, tlbl)
                        ) {
                          addWork(
                            ps,
                            ts,
                            t,
                            asNext,
                            sumVec(vec, asVec),
                            Post(tOp.postW, preLbl)
                          )
                        }
                      }
                    }
                  }
                }
              }

              case Right(eTran) => {
                val tOp = operation(eTran)
                tOp.op match {
                  case NOP => {
                    // deleting an e-label means doing nothing
                    addWork(ps, ts, t, as, vec, EPost(tOp.postW))
                  }
                  case Internal => {
                    for ((asNext, asVec) <- internalMap(as))
                      addWork(ps, ts, t, asNext, sumVec(vec, asVec), EPost(tOp.postW))
                  }
                  case Plus(_) => {
                    // treat as delete -- can't shift e-tran
                    addWork(ps, ts, t, as, vec, EPost(tOp.postW))
                  }
                }
              }
            }
          }
          case Post(v, lbl) if !v.isEmpty => {
            val a = v.head
            val rest = v.tail
            for ((asNext, albl, asVec) <- aut.outgoingTransitionsWithVec(as)) {
              if (aut.LabelOps.labelContains(a, albl))
                addWork(ps, ts, t, asNext, sumVec(vec, asVec), Post(rest, lbl))
            }
          }
          case Post(v, lbl) if v.isEmpty => {
            val tsNext = dest(t)
            val psNext = getState(dest(t), as)

            ceAut.addTransition(ps, lbl, psNext, vec)

            reachStates(tsNext, as)
          }
          case EPost(v) if !v.isEmpty => {
            val a = v.head
            val rest = v.tail
            for ((asNext, albl, asVec) <- aut.outgoingTransitionsWithVec(as)) {
              if (aut.LabelOps.labelContains(a, albl))
                addWork(ps, ts, t, asNext, sumVec(vec, asVec), EPost(rest))
            }
          }
          case EPost(v) if v.isEmpty => {
            val tsNext = dest(t)
            val psNext = getState(dest(t), as)

            epsilonPairs += ((ps, psNext, vec))

            reachStates(tsNext, as)
          }
        }
      }

      def addEpsilonWithVec(ps: State, pt: State, vec: Seq[Int]) {
        if (ceAut.isAccept(pt)) ceAut.setAccept(ps, true)
        for ((to, lbl, pVec) <- ceAut.outgoingTransitionsWithVec(pt)) {
          ceAut.addTransition(ps, lbl, to, sumVec(vec, pVec))
        }
      }
      for ((ps, pt, vec) <- epsilonPairs) {
        addEpsilonWithVec(ps, pt, vec)
      }
      ceAut
    }

  /** Apply the transducer to the input, replacing any internal characters with
    * the given string.
    *
    * Assumes transducer is functional, so returns the first found output
    */
  def apply(input: String, internal: String = ""): Option[String] = {
    if (input.size == 0 && isAccept(_initialState))
      return Some("")

    val worklist = new MStack[(State, Int, String)]
    val seenlist = new MHashSet[(State, Int)]

    worklist.push((_initialState, 0, ""))

    while (!worklist.isEmpty) {
      val (s, pos, output) = worklist.pop

      if (pos < input.size) {
        val a = input(pos)
        for (ts <- _lblTrans.get(s); t <- ts) {
          val pnext = pos + 1
          val snext = dest(t)
          val lbl = label(t)
          if (
            LabelOps.labelContains(a, lbl) && !seenlist.contains((snext, pnext))
          ) {
            val tOp = operation(t)
            val opOut = tOp.op match {
              case NOP      => ""
              case Internal => internal
              case Plus(n)  => (a + n).toChar.toString
            }
            val outnext =
              output + tOp.preW.mkString + opOut + tOp.postW.mkString
            if (pnext >= input.length && isAccept(snext))
              return Some(outnext)
            worklist.push((snext, pnext, outnext))
          }
        }
      }

      for (ts <- _eTrans.get(s); t <- ts) {
        val pnext = pos
        val snext = dest(t)
        if (!seenlist.contains((snext, pnext))) {
          val tOp = operation(t)
          val opOut = tOp.op match {
            case NOP      => ""
            case Internal => internal
            // treat as delete
            case Plus(_) => ""
          }
          val outnext = output + tOp.preW.mkString + opOut + tOp.postW.mkString
          if (pnext >= input.length && isAccept(snext))
            return Some(outnext)
          worklist.push((snext, pnext, outnext))
        }
      }
    }

    return None
  }

  def newState(): State = {
    stateidx += 1
    new State() {
      val idx = stateidx
      override def toString(): String = {
        s"s${idx}"
      }
    }
  }

  def setAccept(s: State, isAccept: Boolean) = if (isAccept) _acceptingStates += s
  def initialState_=(s: State) = _initialState = s
  def initialState = _initialState

  def addTransition(from: State, lbl: TLabel, op: OutputOp, to: State) = {
    _lblTrans.get(from) match {
      case Some(set) => set.add((lbl, op, to))
      case None      => _lblTrans.put(from, MHashSet((lbl, op, to)))
    }
  }

  def addETransition(from: State, op: OutputOp, to: State) = {
    _eTrans.get(from) match {
      case Some(set) => set.add((op, to))
      case None      => _eTrans.put(from, MHashSet((op, to)))
    }
  }

  def minimize() = {
    def dest(t: TTransition): State = t._3
    def edest(t: TETransition): State = t._2

    val fwdReach = new MHashSet[State]
    val bwdMap = new MHashMap[State, MSet[State]] with MMultiMap[State, State]
    val worklist = new MStack[State]

    fwdReach += _initialState
    worklist.push(_initialState)

    while (!worklist.isEmpty) {
      val s = worklist.pop
      for (trans <- _lblTrans.get(s); t <- trans) {
        val snext = dest(t)
        bwdMap.addBinding(snext, s)
        if (fwdReach.add(snext))
          worklist.push(snext)
      }
      for (trans <- _eTrans.get(s); t <- trans) {
        val snext = edest(t)
        bwdMap.addBinding(snext, s)
        if (fwdReach.add(snext))
          worklist.push(snext)
      }
    }

    val bwdReach = new MHashSet[State]

    for (s <- fwdReach; if isAccept(s)) {
      bwdReach += s
      worklist.push(s)
    }

    while (!worklist.isEmpty) {
      val s = worklist.pop

      for (
        snexts <- bwdMap.get(s);
        snext <- snexts;
        if fwdReach.contains(snext)
      )
        if (bwdReach.add(snext))
          worklist.push(snext)
    }

    _acceptingStates.retain(bwdReach.contains(_))
    _lblTrans.retain((k, v) => bwdReach.contains(k))
    _eTrans.retain((k, v) => bwdReach.contains(k))
    _lblTrans.foreach({ case (k, v) =>
      v.retain(t => bwdReach.contains(dest(t)))
    })
    _eTrans.foreach({ case (k, v) =>
      v.retain(t => bwdReach.contains(edest(t)))
    })
  }

  override def toString = {
    "init: " + _initialState + "\n" +
      "finals: " + _acceptingStates + "\n" +
      _lblTrans.mkString("\n") +
      _eTrans.mkString("\n")
  }

  def toDot(): String = {
    val sb = new StringBuilder()
    sb.append("digraph transducer {\n")

    sb.append(_initialState + "[shape=square];\n")
    for (f <- _acceptingStates)
      sb.append(f + "[peripheries=2];\n")

    for (trans <- _lblTrans) {
      val (state, arrows) = trans
      for (arrow <- arrows) {
        val (lbl, op, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"" + lbl + "/" + op + "\"];\n")
      }
    }

    for (trans <- _eTrans) {
      val (state, arrows) = trans
      for (arrow <- arrows) {
        val (op, dest) = arrow
        sb.append(state + " -> " + dest);
        sb.append("[label=\"epsilon /" + op + "\"];\n")
      }
    }

    sb.append("}\n")

    return sb.toString()
  }

}
