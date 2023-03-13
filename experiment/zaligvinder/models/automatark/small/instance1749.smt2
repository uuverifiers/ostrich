(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(www\.|http:\/\/|https:\/\/|http:\/\/www\.|https:\/\/www\.)[a-z0-9]+\.[a-z]{2,4}$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "www.") (str.to_re "http://") (str.to_re "https://") (str.to_re "http://www.") (str.to_re "https://www.")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 4) (re.range "a" "z")) (str.to_re "/\u{0a}"))))
; LogsHXLogOnlytoolbar\x2Ei-lookup\x2Ecom
(assert (str.in_re X (str.to_re "LogsHXLogOnlytoolbar.i-lookup.com\u{0a}")))
(check-sat)
