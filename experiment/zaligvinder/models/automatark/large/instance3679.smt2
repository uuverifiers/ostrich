(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}appendChild.*?\u{2e}id.{0,200}?(offset|client)(Height|Left|Parent|Top|Width).{0,200}?(offset|client)(Height|Left|Parent|Top|Width)/is
(assert (str.in_re X (re.++ (str.to_re "/.appendChild") (re.* re.allchar) (str.to_re ".id") ((_ re.loop 0 200) re.allchar) (re.union (str.to_re "offset") (str.to_re "client")) (re.union (str.to_re "Height") (str.to_re "Left") (str.to_re "Parent") (str.to_re "Top") (str.to_re "Width")) ((_ re.loop 0 200) re.allchar) (re.union (str.to_re "offset") (str.to_re "client")) (re.union (str.to_re "Height") (str.to_re "Left") (str.to_re "Parent") (str.to_re "Top") (str.to_re "Width")) (str.to_re "/is\u{0a}"))))
(check-sat)
