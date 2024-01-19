(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\[a url=\"[^\[\]\"]*\"\])([^\[\]]+)(\[/a\])
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "[/a]\u{0a}[a url=\u{22}") (re.* (re.union (str.to_re "[") (str.to_re "]") (str.to_re "\u{22}"))) (str.to_re "\u{22}]")))))
; ^\d{0,2}(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3A\d+\.compress.*sidebar\.activeshopper\.com
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re ".compress") (re.* re.allchar) (str.to_re "sidebar.activeshopper.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
