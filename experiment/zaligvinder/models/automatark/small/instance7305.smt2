(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([(]?\d{3}[)]?(-| |.)?\d{3}(-| |.)?\d{4})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") (str.to_re " ") re.allchar)) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") re.allchar)) ((_ re.loop 4 4) (re.range "0" "9"))))))
; SecureNet.*\x2Fsearchfast\x2F
(assert (not (str.in_re X (re.++ (str.to_re "SecureNet") (re.* re.allchar) (str.to_re "/searchfast/\u{0a}")))))
; url=\"([^\[\]\"]*)\"
(assert (str.in_re X (re.++ (str.to_re "url=\u{22}") (re.* (re.union (str.to_re "[") (str.to_re "]") (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}"))))
(check-sat)
