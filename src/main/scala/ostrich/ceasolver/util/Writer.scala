package ostrich.ceasolver.util

import java.io.{File, BufferedWriter, FileWriter}

trait Writer {

  val filename: String

  val file: File

  val writer: BufferedWriter

  def write(s: String) = writer.write(s)

  def closeAfterWrite(s: String) = {
    write(s)
    close()
  }

  def newline() = writer.newLine()

  def close() = writer.close()

  def flush() = writer.flush()
}

class TmpWriter extends Writer {

  val filename: String = "tmp.txt"

  val file = new File(filename)

  val writer = new BufferedWriter(new FileWriter(file))
}

class Logger extends TmpWriter {
  override val filename: String = "log.txt"

  def log(s: String) = {
    write(s)
    newline()
    writer.flush()
  }

  override def close(): Unit = {
    writer.close()
  }
}

class CatraWriter(override val filename: String) extends TmpWriter

class DotWriter(override val filename: String) extends TmpWriter
