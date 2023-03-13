(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; corep\x2Edmcast\x2Ecom\s+FunWebProducts\sMycount\x2Eyok\x2EcomProBuilt-inBasicYWRtaW46cGFzc3dvcmQ
(assert (str.in_re X (re.++ (str.to_re "corep.dmcast.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "FunWebProducts") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Mycount.yok.comProBuilt-inBasicYWRtaW46cGFzc3dvcmQ\u{0a}"))))
; (^\d{1,5}$|^\d{1,5}\.\d{1,2}$)
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}rjs/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rjs/i\u{0a}"))))
; twfofrfzlugq\u{2f}eve\.qd\d+
(assert (str.in_re X (re.++ (str.to_re "twfofrfzlugq/eve.qd") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.++ (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")) (str.to_re ":"))) (str.to_re "\u{0a}") (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F")) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))))))
(check-sat)
