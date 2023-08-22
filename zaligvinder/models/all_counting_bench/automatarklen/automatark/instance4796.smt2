(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,4}?[.]{0,1}?\d{0,3}?)$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 4) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 3) (re.range "0" "9")))))
; CD\x2F\.ico\x2FsLogearch195\.225\.
(assert (not (str.in_re X (str.to_re "CD/.ico/sLogearch195.225.\u{0a}"))))
; ad\x2Emokead\x2Ecom\d+Spy\d+ZOMBIES\u{5f}HTTP\u{5f}GETearch\x2Eearthlinkwww\x2Epurityscan\x2EcomUser-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "ad.mokead.com") (re.+ (re.range "0" "9")) (str.to_re "Spy") (re.+ (re.range "0" "9")) (str.to_re "ZOMBIES_HTTP_GETearch.earthlinkwww.purityscan.comUser-Agent:\u{0a}"))))
; ^213\.61\.220\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])$
(assert (str.in_re X (re.++ (str.to_re "213.61.220.") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
