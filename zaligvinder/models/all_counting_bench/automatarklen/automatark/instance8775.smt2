(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; A-311\s+lnzzlnbk\u{2f}pkrm\.finSubject\u{3a}Basic
(assert (not (str.in_re X (re.++ (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.finSubject:Basic\u{0a}")))))
; SurveillanceacezHost\x3Acouponbar\.coupons\.comLOG
(assert (str.in_re X (str.to_re "Surveillance\u{13}acezHost:couponbar.coupons.comLOG\u{0a}")))
; xmlHost\x3ADAPCURLBlazeActivity
(assert (str.in_re X (str.to_re "xmlHost:DAPCURLBlazeActivity\u{0a}")))
; /RegExp?\u{23}.{0,5}\u{28}\u{3f}[^\u{29}]{0,4}i.*?\u{28}\u{3f}\u{2d}[^\u{29}]{0,4}i.{0,50}\u{7c}\u{7c}/smi
(assert (str.in_re X (re.++ (str.to_re "/RegEx") (re.opt (str.to_re "p")) (str.to_re "#") ((_ re.loop 0 5) re.allchar) (str.to_re "(?") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") (re.* re.allchar) (str.to_re "(?-") ((_ re.loop 0 4) (re.comp (str.to_re ")"))) (str.to_re "i") ((_ re.loop 0 50) re.allchar) (str.to_re "||/smi\u{0a}"))))
; ^(([a-zA-Z]{3})?([0-9]{4}))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 4 4) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
