(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((0[13-7]|1[1235789]|[257][0-9]|3[0-35-9]|4[0124-9]|6[013-79]|8[0124-9]|9[0-5789])[0-9]{3}|10([2-9][0-9]{2}|1([2-9][0-9]|11[5-9]))|14([01][0-9]{2}|715))
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (re.range "3" "7"))) (re.++ (str.to_re "1") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8") (str.to_re "9"))) (re.++ (re.union (str.to_re "2") (str.to_re "5") (str.to_re "7")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (re.range "0" "3") (re.range "5" "9"))) (re.++ (str.to_re "4") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (re.range "4" "9"))) (re.++ (str.to_re "6") (re.union (str.to_re "0") (str.to_re "1") (re.range "3" "7") (str.to_re "9"))) (re.++ (str.to_re "8") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "2") (re.range "4" "9"))) (re.++ (str.to_re "9") (re.union (re.range "0" "5") (str.to_re "7") (str.to_re "8") (str.to_re "9")))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "10") (re.union (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "1") (re.union (re.++ (re.range "2" "9") (re.range "0" "9")) (re.++ (str.to_re "11") (re.range "5" "9")))))) (re.++ (str.to_re "14") (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "715")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}flac/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flac/i\u{0a}"))))
; ^(([0-9]{2,4})([-\s\/]{0,1})([0-9]{4,8}))?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ ((_ re.loop 2 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 8) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
