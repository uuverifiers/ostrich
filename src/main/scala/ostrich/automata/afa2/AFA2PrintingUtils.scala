/**
 * This file is part of Ostrich, an SMT solver for strings.
 * Copyright (c) 2022-2024 Riccado De Masellis. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * 
 * * Neither the name of the authors nor the names of their
 *   contributors may be used to endorse or promote products derived from
 *   this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ostrich.automata.afa2

import ostrich.automata.afa2.concrete.{AFA2}
import ostrich.automata.afa2.symbolic.{EpsAFA2, SymbAFA2, SymbExtAFA2}

import java.io.{BufferedWriter, File, FileWriter}
import scala.collection.mutable

/*
Classes for printing to dot file the several different versions of 2AFA
 */

object AFA2PrintingUtils {

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

  def toDot(aut: SymbExtAFA2): String = {
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
        case StepTransition(label, Left, _) => res.append(" -> " + target + " [label=\"<- " + label + "\"")
        case StepTransition(label, Right, _) => res.append(" -> " + target + " [label=\"-> " + label + "\"")
        case SymbTransition(_, Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case SymbTransition(_, Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case EpsTransition(_) => res.append(" -> " + target + " [label=\"eps\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n")
    res.toString()
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
        case StepTransition(label, Left, _) => res.append(" -> " + target + " [label=\"<- " + label + "\"")
        case StepTransition(label, Right, _) => res.append(" -> " + target + " [label=\"-> " + label + "\"")
        case SymbTransition(_, Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case SymbTransition(_, Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case EpsTransition(_) => res.append(" -> " + target + " [label=\"eps\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n")
    res.toString()
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
        case StepTransition(label, Left, _) => res.append(" -> " + target + " [label=\"<- " + label + "\"")
        case StepTransition(label, Right, _) => res.append(" -> " + target + " [label=\"-> " + label + "\"")
        //case SymbTransition(_, AFA2.Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        //case SymbTransition(_, AFA2.Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n")
    res.toString()
  }


  def toDot(aut: SymbAFA2): String = {
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
        case SymbTransition(_, Left, _) => res.append(" -> " + target + " [label=\"<- " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
        case SymbTransition(_, Right, _) => res.append(" -> " + target + " [label=\"-> " + t.asInstanceOf[SymbTransition].toStringLabel() + "\"")
      }

      // universal transitions are red
      if (t.targets.length > 1) res.append(",color=" + color)
      res.append("]\n")
    }
    res.append("}\n")
    res.toString()
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


  def printAutDotToFile(aut: SymbAFA2, fileName: String): Unit = {
    //val path = Paths.get("/out")
    //Files.createDirectories(path)
    //val file = new File("/out/"+fileName)
    val file = new File(fileName)
    val bw = new BufferedWriter(new FileWriter(file))
    bw.write(toDot(aut))
    bw.close()
  }


}
