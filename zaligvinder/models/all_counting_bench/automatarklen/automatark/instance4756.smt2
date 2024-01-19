(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; comLOGUser-Agent\x3Aistsvcwww\x2Eoemji\x2EcomSystemSleuth
(assert (str.in_re X (str.to_re "comLOGUser-Agent:istsvcwww.oemji.comSystemSleuth\u{13}\u{0a}")))
; ^1?[1-2]$|^[1-9]$|^[1]0$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "1")) (re.range "1" "2")) (re.range "1" "9") (str.to_re "10\u{0a}"))))
; /filename=[^\n]*\u{2e}plf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plf/i\u{0a}")))))
; ^((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*);|(0|[1-9]+[0-9]*);)*?((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*)|(0|[1-9]+[0-9]*)){1}$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")) (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")))) ((_ re.loop 1 1) (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; Port\x2Ebody=ocllceclbhs\u{2f}gthWeComputerLoggerHost\x3Agdvsotuqwsg\u{2f}dxt\.hd^User-Agent\x3A
(assert (str.in_re X (str.to_re "Port.body=ocllceclbhs/gthWeComputerLoggerHost:gdvsotuqwsg/dxt.hdUser-Agent:\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
