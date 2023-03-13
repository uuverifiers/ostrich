(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^127\.0\.0\.1)
(assert (str.in_re X (re.union (str.to_re "10.") (re.++ (str.to_re "172.1") (re.range "6" "9") (str.to_re ".")) (re.++ (str.to_re "172.2") (re.range "0" "9") (str.to_re ".")) (re.++ (str.to_re "172.3") (re.range "0" "1") (str.to_re ".")) (str.to_re "192.168.") (str.to_re "127.0.0.1\u{0a}"))))
; PASSW=.*www\x2Emakemesearch\x2Ecom.*HBand,X-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "PASSW=") (re.* re.allchar) (str.to_re "www.makemesearch.com") (re.* re.allchar) (str.to_re "HBand,X-Mailer:\u{13}\u{0a}")))))
; ^((((0031)|(\+31))(\-)?6(\-)?[0-9]{8})|(06(\-)?[0-9]{8})|(((0031)|(\+31))(\-)?[1-9]{1}(([0-9](\-)?[0-9]{7})|([0-9]{2}(\-)?[0-9]{6})))|([0]{1}[1-9]{1}(([0-9](\-)?[0-9]{7})|([0-9]{2}(\-)?[0-9]{6}))))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "0031") (str.to_re "+31")) (re.opt (str.to_re "-")) (str.to_re "6") (re.opt (str.to_re "-")) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (str.to_re "06") (re.opt (str.to_re "-")) ((_ re.loop 8 8) (re.range "0" "9"))) (re.++ (re.union (str.to_re "0031") (str.to_re "+31")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "1" "9")) (re.union (re.++ (re.range "0" "9") (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")) (re.union (re.++ (re.range "0" "9") (re.opt (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(check-sat)
