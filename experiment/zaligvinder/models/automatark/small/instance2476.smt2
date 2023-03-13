(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \<img ((src|height|width|border)=:q:Wh*)*/\>
(assert (str.in_re X (re.++ (str.to_re "<img ") (re.* (re.++ (re.union (str.to_re "src") (str.to_re "height") (str.to_re "width") (str.to_re "border")) (str.to_re "=:q:W") (re.* (str.to_re "h")))) (str.to_re "/>\u{0a}"))))
; /\u{2f}\{\u{23}[^\u{2f}{}]+?\}(\.action)?\u{2f}?$/miU
(assert (not (str.in_re X (re.++ (str.to_re "//{#") (re.+ (re.union (str.to_re "/") (str.to_re "{") (str.to_re "}"))) (str.to_re "}") (re.opt (str.to_re ".action")) (re.opt (str.to_re "/")) (str.to_re "/miU\u{0a}")))))
; /^\u{2f}[0-9A-F]{42}$/Um
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 42 42) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re "/Um\u{0a}")))))
(check-sat)
