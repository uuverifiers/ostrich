(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{0d}\u{0a}Host\u{3a}\u{20}[^\u{0d}\u{0a}\u{2e}]+\u{2e}[^\u{0d}\u{0a}\u{2e}]+(\u{3a}\d{1,5})?\u{0d}\u{0a}\u{0d}\u{0a}$/H
(assert (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Host: ") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "."))) (str.to_re ".") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "."))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0d}\u{0a}\u{0d}\u{0a}/H\u{0a}"))))
; Host\x3AYOURcache\x2Eeverer\x2Ecomwww\x2Epurityscan\x2Ecom
(assert (str.in_re X (str.to_re "Host:YOURcache.everer.comwww.purityscan.com\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
