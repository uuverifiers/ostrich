package ostrich.automata.afa2

import ostrich.automata.afa2.AFA2.{EpsTransition, StepTransition, SymbTransition}

import java.io.{BufferedWriter, File, FileWriter}
import scala.collection.{breakOut, mutable}

object AFA2Utils {

  val svg = Array("aqua", "aquamarine",
    "blue", "blueviolet", "brown",
    "burlywood",
    "cadetblue", "chartreuse", "chocolate",
    "coral",
    "cornflowerblue", "crimson",
    "cyan",
    "darkblue", "darkcyan", "darkgoldenrod",
    "darkgray",
    "darkgreen", "darkgrey", "darkkhaki",
    "darkmagenta",
    "darkolivegreen", "darkorange", "darkorchid",
    "darkred",
    "darksalmon", "darkseagreen", "darkslateblue",
    "darkslategray",
    "darkslategrey", "darkturquoise", "darkviolet",
    "deeppink",
    "deepskyblue", "dimgray", "dimgrey",
    "dodgerblue",
    "firebrick", "forestgreen",
    "fuchsia",
    "gainsboro", "gold",
    "goldenrod",
    "gray", "green", "greenyellow",
    "grey", "hotpink", "indianred",
    "indigo", "khaki",
    "lawngreen", "lightblue",
    "lightcoral", "lightgray",
    "lightgreen",
    "lightgrey", "lightpink", "lightsalmon",
    "lightseagreen",
    "lightskyblue", "lightslategray", "lightslategrey",
    "lightsteelblue", "lime", "limegreen",
    "magenta", "maroon", "mediumaquamarine",
    "mediumblue",
    "mediumorchid", "mediumpurple", "mediumseagreen",
    "mediumslateblue",
    "mediumspringgreen", "mediumturquoise", "mediumvioletred",
    "midnightblue",
    "navy", "olive",
    "olivedrab",
    "orange", "orangered", "orchid",
    "palegreen", "paleturquoise", "palevioletred",
    "peachpuff", "peru", "pink",
    "plum",
    "powderblue", "purple", "red",
    "rosybrown",
    "royalblue", "saddlebrown", "salmon",
    "sandybrown",
    "seagreen", "sienna",
    "silver",
    "skyblue", "slateblue", "slategray",
    "slategrey", "springgreen", "steelblue",
    "tan",
    "teal", "thistle", "tomato",
    "turquoise",
    "violet")

  /*
  Given a set ranges of (non-overlapping) Ranges, and a given a new range toRem, it subtracts toRem
  to ranges, as follows:
  (1) - generate first an ordered Seq[Int] of integers in ranges but not in toRem
  (2) - reconstruct the set of Ranges from the Seq[Int]
   */
  def rangeDiff(ranges: Set[Range], toRem: Range) : Set[Range] = {
    // Step (1)
    val newSeq = ((for (rng <- ranges) yield rng.filter(x => !toRem.contains(x))).flatten).toIndexedSeq.sorted(Ordering[Int])

    //Step (2). Sweeping newSeq with two indexes until next element is previous+1
    val newRanges = mutable.Set[Range]()
    var lastInd, currInd = 0
    //println("Indexes set = " + newSeq.indices)
    if (newSeq.nonEmpty) {
      while (currInd < newSeq.length) {
        if (currInd + 1 < newSeq.length && newSeq(currInd + 1) != newSeq(currInd) + 1) {
          newRanges += (new Range(newSeq(lastInd), newSeq(currInd) + 1, 1))
          lastInd = currInd + 1
        }
        currInd += 1
      }
      newRanges += (new Range(newSeq(lastInd), newSeq(currInd - 1) + 1, 1))
    }
    newRanges.toSet
  }



  def toDot(aut: SymbExtAFA2): String = {
    val res = new mutable.StringBuilder("digraph Automaton {\n")
    res.append("  rankdir = LR;\n")
    res.append("  initial [shape=plaintext,label=\"\"];\n");

    // Printing states
    for (s <- aut.states) {
      res.append("  " + s)

      if (aut.finalBeginStates.contains(s) || aut.finalEndStates.contains(s)) res.append(" [shape=doublecircle,label=\"" + s + "\"];\n")
      else res.append(" [shape=circle,label=\"" + s + "\"];\n")

      if (aut.initialStates.contains(s)) {
        res.append("  initial -> " + s + "\n")
      }
    }

    // printing transitions
    for ((source, transitions) <- aut.transitions;
         t <- transitions; rand = scala.util.Random; color = svg(rand.nextInt(svg.length));
         target <- t.targets) {

      res.append("  " + source)
      t match {
        case StepTransition(label, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + label + "\"")
        case StepTransition(label, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + label + "\"")
        case SymbTransition(_, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case SymbTransition(_, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case EpsTransition(_) => res.append(" -> " + target + " [label=\"eps\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n") toString()
  }

  def toDot(aut: ExtAFA2): String = {
    val res = new mutable.StringBuilder("digraph Automaton {\n")
    res.append("  rankdir = LR;\n")
    res.append("  initial [shape=plaintext,label=\"\"];\n");

    // Printing states
    for (s <- aut.states) {
      res.append("  " + s)

      if (aut.finalLeftStates.contains(s) || aut.finalRightStates.contains(s)) res.append(" [shape=doublecircle,label=\"" + s + "\"];\n")
      else res.append(" [shape=circle,label=\"" + s + "\"];\n")

      if (aut.initialStates.contains(s)) {
        res.append("  initial -> " + s + "\n")
      }
    }

    // printing transitions
    for ((source, transitions) <- aut.transitions;
         t <- transitions; rand = scala.util.Random; color = svg(rand.nextInt(svg.length));
         target <- t.targets) {

      res.append("  " + source)
      t match {
        case StepTransition(label, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + label + "\"")
        case StepTransition(label, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + label + "\"")
        case SymbTransition(_, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case SymbTransition(_, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case EpsTransition(_) => res.append(" -> " + target + " [label=\"eps\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n") toString()
  }

  def toDot(aut: EpsAFA2): String = {
    val res = new mutable.StringBuilder("digraph Automaton {\n")
    res.append("  rankdir = LR;\n")
    res.append("  initial [shape=plaintext,label=\"\"];\n");

    // Printing states
    for (s <- aut.states) {
      res.append("  " + s)

      if (aut.finalStates.contains(s)) res.append(" [shape=doublecircle,label=\"" + s + "\"];\n")
      else res.append(" [shape=circle,label=\"" + s + "\"];\n")

      if (aut.initialState == s) {
        res.append("  initial -> " + s + "\n")
      }
    }

    // printing transitions
    for ((source, transitions) <- aut.transitions;
         t <- transitions; rand = scala.util.Random; color = svg(rand.nextInt(svg.length));
         target <- t.targets) {

      res.append("  " + source)
      t match {
        case StepTransition(label, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + label + "\"")
        case StepTransition(label, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + label + "\"")
        //case SymbTransition(_, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        //case SymbTransition(_, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case EpsTransition(_) => res.append(" -> " + target + " [label=\"eps\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n") toString()
  }


  def toDot(aut: AFA2): String = {
    val res = new mutable.StringBuilder("digraph Automaton {\n")
    res.append("  rankdir = LR;\n")
    res.append("  initial [shape=plaintext,label=\"\"];\n");

    // Printing states
    for (s <- aut.states) {
      res.append("  " + s)

      if (aut.finalStates.contains(s)) res.append(" [shape=doublecircle,label=\"" + s + "\"];\n")
      else res.append(" [shape=circle,label=\"" + s + "\"];\n")

      if (aut.initialStates.contains(s)) {
        res.append("  initial -> " + s + "\n")
      }
    }

    // printing transitions
    for ((source, transitions) <- aut.transitions;
         t <- transitions; rand = scala.util.Random; color = svg(rand.nextInt(svg.length));
         target <- t.targets) {

      res.append("  " + source)
      t match {
        case StepTransition(label, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + label + "\"")
        case StepTransition(label, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + label + "\"")
        //case SymbTransition(_, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        //case SymbTransition(_, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n") toString()
  }


  def printAutDotToFile(aut: SymbExtAFA2, fileName: String): Unit = {
    //val path = Paths.get("/out")
    //Files.createDirectories(path)
    //val file = new File("/out/"+fileName)
    val file = new File(fileName)
    val bw = new BufferedWriter(new FileWriter(file))
    bw.write(toDot(aut))
    bw.close()
  }

  def printAutDotToFile(aut: ExtAFA2, fileName: String): Unit = {
    //val path = Paths.get("/out")
    //Files.createDirectories(path)
    //val file = new File("/out/"+fileName)
    val file = new File(fileName)
    val bw = new BufferedWriter(new FileWriter(file))
    bw.write(toDot(aut))
    bw.close()
  }


  def printAutDotToFile(aut: EpsAFA2, fileName: String): Unit = {
    //val path = Paths.get("/out")
    //Files.createDirectories(path)
    //val file = new File("/out/"+fileName)
    val file = new File(fileName)
    val bw = new BufferedWriter(new FileWriter(file))
    bw.write(toDot(aut))
    bw.close()
  }

  def printAutDotToFile(aut: AFA2, fileName: String): Unit = {
    //val path = Paths.get("/out")
    //Files.createDirectories(path)
    //val file = new File("/out/"+fileName)
    val file = new File(fileName)
    val bw = new BufferedWriter(new FileWriter(file))
    bw.write(toDot(aut))
    bw.close()
  }


}
