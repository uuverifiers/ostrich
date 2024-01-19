(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}(jpg|png|gif)\u{3f}s?v.*?&tq=g[A-Z0-9]{2}/U
(assert (str.in_re X (re.++ (str.to_re "/.") (re.union (str.to_re "jpg") (str.to_re "png") (str.to_re "gif")) (str.to_re "?") (re.opt (str.to_re "s")) (str.to_re "v") (re.* re.allchar) (str.to_re "&tq=g") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; /^Content-Type\u{3a}[\u{20}\u{09}]+application\/octet-stream/smiH
(assert (not (str.in_re X (re.++ (str.to_re "/Content-Type:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (str.to_re "application/octet-stream/smiH\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
