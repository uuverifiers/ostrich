(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(\u{00}\u{00}\u{00}\u{00}|.{4}(\u{00}\u{00}\u{00}\u{00}|.{12}))/s
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") (re.++ ((_ re.loop 4 4) re.allchar) (re.union (str.to_re "\u{00}\u{00}\u{00}\u{00}") ((_ re.loop 12 12) re.allchar)))) (str.to_re "/s\u{0a}")))))
; Host\u{3a}SoftwareHost\x3AjokeWEBCAM-Server\u{3a}
(assert (not (str.in_re X (str.to_re "Host:SoftwareHost:jokeWEBCAM-Server:\u{0a}"))))
; ^\d+$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Host\x3A\dwww\x2Etrustedsearch\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "www.trustedsearch.com\u{0a}")))))
(check-sat)
