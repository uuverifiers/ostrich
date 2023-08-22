(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AUser-Agent\u{3a}URLencoderthis\x7CConnected
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:URLencoderthis|Connected\u{0a}"))))
; Referer\x3AUser-Agent\x3AFrom\x3AUser-Agent\x3Aadfsgecoiwnf
(assert (not (str.in_re X (str.to_re "Referer:User-Agent:From:User-Agent:adfsgecoiwnf\u{1b}\u{0a}"))))
; ^(\d|,)*\.?\d*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (str.to_re ","))) (re.opt (str.to_re ".")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
; \b[1-9]{1}[0-9]{1,5}-\d{2}-\d\b
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
