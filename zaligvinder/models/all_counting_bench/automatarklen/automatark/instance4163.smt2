(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d+((\.|\,)\d+)?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^[^';<>?%!\s]{1,20}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (str.to_re "'") (str.to_re ";") (str.to_re "<") (str.to_re ">") (str.to_re "?") (str.to_re "%") (str.to_re "!") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; (^N/A$)|(^[-]?(\d+)(\.\d{0,3})?$)|(^[-]?(\d{1,3},(\d{3},)*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{1,3})?)$)
(assert (not (str.in_re X (re.union (str.to_re "N/A") (re.++ (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9"))))) (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))))))))))
(assert (> (str.len X) 10))
(check-sat)
