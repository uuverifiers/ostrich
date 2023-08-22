(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\.php\?hgfc\=[a-f0-9]+$/U
(assert (not (str.in_re X (re.++ (str.to_re "/.php?hgfc=") (re.+ (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; ^(\+27|27)?(\()?0?([7][1-9]|[8][2-4])(\))?( |-|\.|_)?(\d{3})( |-|\.|_)?(\d{4})
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+27") (str.to_re "27"))) (re.opt (str.to_re "(")) (re.opt (str.to_re "0")) (re.union (re.++ (str.to_re "7") (re.range "1" "9")) (re.++ (str.to_re "8") (re.range "2" "4"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}dae([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.dae") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^((\d){3})(-)?(\d){2}(-)?(\d){4}(A|B[1-7]?|M|T|C[1-4]|D)$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.union (str.to_re "A") (re.++ (str.to_re "B") (re.opt (re.range "1" "7"))) (str.to_re "M") (str.to_re "T") (re.++ (str.to_re "C") (re.range "1" "4")) (str.to_re "D")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
