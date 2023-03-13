(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}(jpg|png|gif)\u{3f}s?v.*?&tq=g[A-Z0-9]{2}/U
(assert (not (str.in_re X (re.++ (str.to_re "/.") (re.union (str.to_re "jpg") (str.to_re "png") (str.to_re "gif")) (str.to_re "?") (re.opt (str.to_re "s")) (str.to_re "v") (re.* re.allchar) (str.to_re "&tq=g") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; LOG\swww\x2Esearchwords\x2EcomHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "LOG") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.searchwords.comHost:\u{0a}")))))
(check-sat)
