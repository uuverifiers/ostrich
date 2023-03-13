(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\$)?(([1-9]\d{0,2}(\,\d{3})*)|([1-9]\d*)|(0))(\.\d{2})?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))))) (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (str.to_re "0")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; \x2Fdss\x2Fcc\.2_0_0\.GoogleHXDownloadasdbiz\x2Ebiz
(assert (str.in_re X (str.to_re "/dss/cc.2_0_0.GoogleHXDownloadasdbiz.biz\u{0a}")))
(check-sat)
