package ostrich.parikh.writer

import uuverifiers.common.Tracing
import uuverifiers.catra.SolveRegisterAutomata
import java.io.{File, BufferedWriter, FileWriter}
import ostrich.parikh.Config

trait Writer {

  val filename: String

  val file : File

  val writer : BufferedWriter 

  def write(s: String) = writer.write(s)

  def closeAfterWrite(s: String) = {
    write(s)
    close()
  }

  def newline() = writer.newLine()

  def close() = writer.close()

  def flush() = writer.flush()
}

class Logger extends Writer {
  val filename: String = (os.pwd / "log.txt").toString()

  val file  = new File(filename)

  val writer = new BufferedWriter(new FileWriter(file))

  def log(s: String) = {
    if (Config.log) {
      write(s)
      newline()
      writer.flush()
    }
  }

  override def close(): Unit = {
    if (Config.log)
      writer.close()
  }
}

class CatraWriter(override val filename: String) extends Logger

class DotWriter(override val filename: String) extends Logger

class TempWriter(override val filename: String) extends Logger
