(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((http:\/\/www\.)|(www\.)|(http:\/\/))[a-zA-Z0-9._-]+\.[a-zA-Z.]{2,5}$
(assert (str.in_re X (re.++ (re.union (str.to_re "http://www.") (str.to_re "www.") (str.to_re "http://")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "."))) (str.to_re "\u{0a}"))))
; for[^\n\r]*Host\x3A\sinternalcyber@yahoo\x2EcomHeadersRedirection
(assert (not (str.in_re X (re.++ (str.to_re "for") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "internalcyber@yahoo.comHeadersRedirection\u{0a}")))))
; www\x2Eweepee\x2Ecom\s+www\x2Ewebfringe\x2Ecomwww\.123mania\.com\x2F0409
(assert (not (str.in_re X (re.++ (str.to_re "www.weepee.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.webfringe.comwww.123mania.com/0409\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
