(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\$|R\$|\-\$|\-R\$|\$\-|R\$\-|-)?([0-9]{1}[0-9]{0,2}(\.[0-9]{3})*(\,[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\,[0-9]{0,2})?|0(\,[0-9]{0,2})?|(\,[0-9]{1,2})?)$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "$") (str.to_re "R$") (str.to_re "-$") (str.to_re "-R$") (str.to_re "$-") (str.to_re "R$-") (str.to_re "-"))) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ",") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.opt (re.++ (str.to_re ",") ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; /\u{2e}avi([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.avi") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /\u{2e}dib([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.dib") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
