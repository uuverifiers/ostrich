(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(1)?(-|.)?(\()?([0-9]{3})(\))?(-|.)?([0-9]{3})(-|.)?([0-9]{4})/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") re.allchar)) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
; (^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^127\.0\.0\.1)
(assert (str.in_re X (re.union (str.to_re "10.") (re.++ (str.to_re "172.1") (re.range "6" "9") (str.to_re ".")) (re.++ (str.to_re "172.2") (re.range "0" "9") (str.to_re ".")) (re.++ (str.to_re "172.3") (re.range "0" "1") (str.to_re ".")) (str.to_re "192.168.") (str.to_re "127.0.0.1\u{0a}"))))
(check-sat)
