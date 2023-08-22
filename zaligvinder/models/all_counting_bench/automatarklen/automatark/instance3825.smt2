(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{3f}sv\u{3d}\d{1,3}\u{26}tq\u{3d}/smiU
(assert (str.in_re X (re.++ (str.to_re "/?sv=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&tq=/smiU\u{0a}"))))
; /\u{2e}(jpg|png|gif)\u{3f}s?v.*?&tq=g[A-Z0-9]{2}/U
(assert (not (str.in_re X (re.++ (str.to_re "/.") (re.union (str.to_re "jpg") (str.to_re "png") (str.to_re "gif")) (str.to_re "?") (re.opt (str.to_re "s")) (str.to_re "v") (re.* re.allchar) (str.to_re "&tq=g") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
