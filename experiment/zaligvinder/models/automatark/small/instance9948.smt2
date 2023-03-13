(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/\d+\/\d\.zip\u{27}\u{3b}/
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "0" "9")) (str.to_re "/") (re.range "0" "9") (str.to_re ".zip';/\u{0a}"))))
; (\[a url=\"[^\[\]\"]*\"\])([^\[\]]+)(\[/a\])
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "[/a]\u{0a}[a url=\u{22}") (re.* (re.union (str.to_re "[") (str.to_re "]") (str.to_re "\u{22}"))) (str.to_re "\u{22}]"))))
; https?://[\d.A-Za-z-]+\.[A-Za-z]{2,6}/?
(assert (not (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.+ (re.union (re.range "0" "9") (str.to_re ".") (re.range "A" "Z") (re.range "a" "z") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 6) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re "/")) (str.to_re "\u{0a}")))))
(check-sat)
