package ostrich.parikh.writer

trait FileWriter {

  protected var file = ""

  def setFile(f: String): Unit = file = f


}
