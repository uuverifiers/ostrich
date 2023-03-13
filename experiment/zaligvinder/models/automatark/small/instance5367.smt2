(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(GB)?([0-9]{9})$
(assert (str.in_re X (re.++ (re.opt (str.to_re "GB")) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[a-zA-Z]+((\s|\-|\')[a-zA-Z]+)?$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.++ (re.union (str.to_re "-") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "\u{0a}"))))
; \x2FrssScaneradfsgecoiwnf\x7D\x7BTrojan\x3AlogsHost\u{3a}
(assert (not (str.in_re X (str.to_re "/rssScaneradfsgecoiwnf\u{1b}}{Trojan:logsHost:\u{0a}"))))
(check-sat)
