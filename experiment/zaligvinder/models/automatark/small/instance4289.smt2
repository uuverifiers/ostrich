(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^5[1-5][0-9]{14}$
(assert (not (str.in_re X (re.++ (str.to_re "5") (re.range "1" "5") ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{3d}\u{3d}$/P
(assert (not (str.in_re X (str.to_re "/==/P\u{0a}"))))
; <script type="text/javascript">
(assert (str.in_re X (str.to_re "<script type=\u{22}text/javascript\u{22}>\u{0a}")))
(check-sat)
