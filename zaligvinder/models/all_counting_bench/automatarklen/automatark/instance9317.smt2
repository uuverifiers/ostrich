(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (((s*)(ftp)(s*)|(http)(s*)|mailto|news|file|webcal):(\S*))|((www.)(\S*))
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (re.* (str.to_re "s")) (str.to_re "ftp") (re.* (str.to_re "s"))) (re.++ (str.to_re "http") (re.* (str.to_re "s"))) (str.to_re "mailto") (str.to_re "news") (str.to_re "file") (str.to_re "webcal")) (str.to_re ":") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) (re.++ (str.to_re "\u{0a}") (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "www") re.allchar))))
; /filename=[^\n]*\u{2e}mov/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mov/i\u{0a}"))))
; /filename=[^\n]*\u{2e}dbp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dbp/i\u{0a}"))))
; ((0[13-7]|1[1235789]|[257][0-9]|3[0-35-9]|4[0124-9]|6[013-79]|8[0124-9]|9[0-5789])[0-9]{3}|10([2-9][0-9]{2}|1([2-9][0-9]|11[5-9]))|14([01][0-9]{2}|715))
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (re.range "3" "7"))) (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (re.union (str.to_re "2") (str.to_re "5") (str.to_re "7")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (re.range "0" "3") (re.range "5" "9"))) (re.++ (str.to_re "4") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (re.range "4" "9"))) (re.++ (str.to_re "6") (re.union (str.to_re "0") (str.to_re "1") (re.range "3" "7") (str.to_re "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (re.range "4" "9"))) (re.++ (str.to_re "9") (re.union (re.range "0" "5") (str.to_re "7") (str.to_re "8") (str.to_re "9")))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "10") (re.union (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.union (re.++ (re.range "2" "9") (re.range "0" "9")) (re.++ (str.to_re "11") (re.range "5" "9")))))) (re.++ (str.to_re "14") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "715")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
