// package ostrich.parikh.automata

// import ap.terfor.Term
// import ap.terfor.Formula
// import ap.terfor.conjunctions.Conjunction


// class VectorAutomationBuilder {
//   type State = VectorAutomaton#State
//   private var stateidx = 0
//   private var initialState = getNewState
//   private var registers: Seq[Term] = Seq()
//   private var regsRelation: Formula = Conjunction.TRUE
//   def setRegisters(_registers: Seq[Term]): Unit = {
//     registers = _registers
//   }
//   def setRegsRelation(_regsRelation: Formula): Unit = {
//     regsRelation = _regsRelation
//   }
//   def setInitialState(_initialState: State): Unit = {
//     initialState = _initialState
//   }

//   def getInitialState: State = initialState
//   def getNewState: State = {
//     stateidx += 1
//     new State() {
//       val idx = stateidx
//       override def toString(): String = {
//         s"s${idx}"
//       }
//     }
//   }
// }

