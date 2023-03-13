(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Fsearchfast\x2Fhoroscope2libManager\x2Edll\x5EgetFreeAccessBarHost\x3Ahostiedesksearch\.dropspam\.com
(assert (str.in_re X (str.to_re "/searchfast/horoscope2libManager.dll^getFreeAccessBarHost:hostiedesksearch.dropspam.com\u{0a}")))
; /^(8-?|\+?7-?)?(\(?\d{3}\)?)-?(\d-?){6}\d$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (re.++ (str.to_re "8") (re.opt (str.to_re "-"))) (re.++ (re.opt (str.to_re "+")) (str.to_re "7") (re.opt (str.to_re "-"))))) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.++ (re.range "0" "9") (re.opt (str.to_re "-")))) (re.range "0" "9") (str.to_re "/\u{0a}") (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")))))
; /^Content-Type\u{3a}[\u{20}\u{09}]+application\/octet-stream/smiH
(assert (str.in_re X (re.++ (str.to_re "/Content-Type:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}"))) (str.to_re "application/octet-stream/smiH\u{0a}"))))
(check-sat)
