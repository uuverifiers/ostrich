(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\d{5}$)|(^\d{5}-\d{4}$)
(assert (str.in_re X (re.union ((_ re.loop 5 5) (re.range "0" "9")) (re.++ (str.to_re "\u{0a}") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))))))
; ^[-+]?\d*\.?\d*$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; <img[^>]*src=\"?([^\"]*)\"?([^>]*alt=\"?([^\"]*)\"?)?[^>]*>
(assert (str.in_re X (re.++ (str.to_re "<img") (re.* (re.comp (str.to_re ">"))) (str.to_re "src=") (re.opt (str.to_re "\u{22}")) (re.* (re.comp (str.to_re "\u{22}"))) (re.opt (str.to_re "\u{22}")) (re.opt (re.++ (re.* (re.comp (str.to_re ">"))) (str.to_re "alt=") (re.opt (str.to_re "\u{22}")) (re.* (re.comp (str.to_re "\u{22}"))) (re.opt (str.to_re "\u{22}")))) (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}"))))
; ^\d{5}-\d{4}$
(assert (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^([A-Z]{2}?(\d{7}))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 7 7) (re.range "0" "9")))))
(assert (> (str.len X) 10))
(check-sat)
