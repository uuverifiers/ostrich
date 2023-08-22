(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \\[\\w{2}\\]
(assert (str.in_re X (re.++ (str.to_re "\u{5c}") (re.union (str.to_re "\u{5c}") (str.to_re "w") (str.to_re "{") (str.to_re "2") (str.to_re "}")) (str.to_re "\u{0a}"))))
; ^\d{5}[- .]?\d{7}[- .]?\d{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^(958([0-9])+([0-9])+([0-9])+([0-9])+([0-9])+([0-9])+)|(958-([0-9])+([0-9])+([0-9])+([0-9])+([0-9])+([0-9])+)$
(assert (not (str.in_re X (re.union (re.++ (str.to_re "958") (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}958-") (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")) (re.+ (re.range "0" "9")))))))
; /\u{2e}jfif?([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jfi") (re.opt (str.to_re "f")) (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; (^[1-9]{1,3}(,\d{3})*$)|(^0$)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 1 3) (re.range "1" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (str.to_re "0\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
