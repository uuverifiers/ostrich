(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [+-]*[0-9]+[,]*[0-9]*|[+-]*[0-9]*[,]+[0-9]*
(assert (not (str.in_re X (re.union (re.++ (re.* (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (re.* (str.to_re ",")) (re.* (re.range "0" "9"))) (re.++ (re.* (re.union (str.to_re "+") (str.to_re "-"))) (re.* (re.range "0" "9")) (re.+ (str.to_re ",")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; /filename=[^\n]*\u{2e}xsl/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xsl/i\u{0a}")))))
; /gate\u{2e}php\u{3f}reg=[a-zA-Z]{15}/U
(assert (not (str.in_re X (re.++ (str.to_re "/gate.php?reg=") ((_ re.loop 15 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "/U\u{0a}")))))
; ^(\d{2,3}|\(\d{2,3}\))?[ ]?\d{3,4}[-]?\d{3,4}$
(assert (not (str.in_re X (re.++ (re.opt (re.union ((_ re.loop 2 3) (re.range "0" "9")) (re.++ (str.to_re "(") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")")))) (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 3 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; 2\x2E41\d+www\x2Erichfind\x2EcomHost\x3ABeyond
(assert (not (str.in_re X (re.++ (str.to_re "2.41") (re.+ (re.range "0" "9")) (str.to_re "www.richfind.comHost:Beyond\u{0a}")))))
(check-sat)
