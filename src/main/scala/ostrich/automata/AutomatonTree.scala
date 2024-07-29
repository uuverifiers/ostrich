
package ostrich.automata

class AutomatonTree {
  private var rootNode : Option[AutomatonTreeNode] = None

  /**
   * Insert aut into the tree and return the id
   *
   * Uses existing automaton if there is an equivalent one
   *
   * @param aut the (possibly) new automaton
   * @param nextId the ID to use if the automaton is genuinely new
   * @return the ID assigned (old or new)
   */
  def insert(aut : Automaton, nextId : Int) : Int = synchronized {
    rootNode match {
      case None => {
        rootNode = Some(new LeafNode(nextId, aut))
        nextId
      }
      case Some(root) => {
        val (id, newRootNode) = root.insert(aut, nextId)
        rootNode = Some(newRootNode)
        id
      }
    }
  }

  private trait AutomatonTreeNode {
    /**
     * Insert aut into the tree, return the ID and updated node
     *
     * The ID will be fresh if the automaton was not already in the tree,
     * else it will be the ID of the existing automaton.
     */
    def insert(newAut : Automaton, nextId : Int) : (Int, AutomatonTreeNode)
  }

  private class InternalNode(
    val distinguishingWord : Seq[Int],
    var yesChild : AutomatonTreeNode,
    var noChild : AutomatonTreeNode
  ) extends AutomatonTreeNode {
    override def insert(
      newAut : Automaton, nextId : Int
    ) : (Int, AutomatonTreeNode) = {
      if (newAut(distinguishingWord)) {
        val (id, newYesChild) = yesChild.insert(newAut, nextId);
        yesChild = newYesChild
        (id, this)
      } else {
        val (id, newNoChild) = noChild.insert(newAut, nextId);
        noChild = newNoChild
        (id, this)
      }
    }
  }

  private class LeafNode(
    val id : Int,
    val aut : Automaton
  ) extends AutomatonTreeNode {
    override def insert(
      newAut : Automaton, nextId : Int
    ) : (Int, AutomatonTreeNode) = {
      checkEquality(aut, newAut) match {
        case (_, None) => (id, this)
        case (i, Some(w)) => {
          val yesChild = if (i == 1) new LeafNode(id, aut)
            else new LeafNode(nextId, newAut)
          val noChild = if (i == 2) new LeafNode(id, aut)
            else new LeafNode(nextId, newAut)
          (nextId, new InternalNode(w, yesChild, noChild))
        }
      }
    }

    /**
     * Check if the two automata are equal
     *
     * Return pair of aut num and distinguishing word if they are not
     * the same. Aut num indicates either aut1 or aut2 -- the one which
     * accepts the word. Return (0, None) if the same.
     */
    private def checkEquality(
      aut1 : Automaton, aut2 : Automaton
    ) : (Int, Option[Seq[Int]]) = {
      if (aut1 == aut2)
        return (0, None)

      val w1 = (aut1 & !aut2).getAcceptedWord
      if (w1.isDefined)
        return (1, w1)

      val w2 = (!aut1 & aut2).getAcceptedWord
      if (w2.isDefined)
        return (2, w2)

      return (0, None)
    }
  }
}
