(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{00}\.\u{00}\.\u{00}[\u{2f}\u{5c}]/R
(assert (not (str.in_re X (re.++ (str.to_re "/\u{00}.\u{00}.\u{00}") (re.union (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "/R\u{0a}")))))
; /((\d){2})?(\s|-)?((\d){2,4})?(\s|-){1}((\d){8})$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.opt ((_ re.loop 2 2) (re.range "0" "9"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt ((_ re.loop 2 4) (re.range "0" "9"))) ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "/\u{0a}")))))
; serverUSER-AttachedReferer\x3AyouPointsUser-Agent\x3AHost\u{3a}
(assert (not (str.in_re X (str.to_re "serverUSER-AttachedReferer:youPointsUser-Agent:Host:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
