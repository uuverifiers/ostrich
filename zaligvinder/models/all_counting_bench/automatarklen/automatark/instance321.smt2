(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\+?972(\-)?0?[23489]{1}(\-)?[^0\D]{1}\d{6}$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (str.to_re "972") (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) ((_ re.loop 1 1) (re.union (str.to_re "2") (str.to_re "3") (str.to_re "4") (str.to_re "8") (str.to_re "9"))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.union (str.to_re "0") (re.comp (re.range "0" "9")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Subject\u{3a}\d+rprpgbnrppb\u{2f}ci
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.+ (re.range "0" "9")) (str.to_re "rprpgbnrppb/ci\u{0a}")))))
; /\?a=dw[a-z]$/U
(assert (not (str.in_re X (re.++ (str.to_re "/?a=dw") (re.range "a" "z") (str.to_re "/U\u{0a}")))))
; HWAEUser-Agent\x3ATestHost\x3Awww\x2Edotcomtoolbar\x2Ecom
(assert (str.in_re X (str.to_re "HWAEUser-Agent:TestHost:www.dotcomtoolbar.com\u{0a}")))
; /(^|&)(db(username|password|)|cp(username|password|domain))=[^&]*?(\u{27}|%27)[^&]*?([\u{3b}\u{60}]|\u{24}\u{28}|%3b|%60|%24%28)/Pmi
(assert (not (str.in_re X (re.++ (str.to_re "/&") (re.union (re.++ (str.to_re "db") (re.union (str.to_re "username") (str.to_re "password"))) (re.++ (str.to_re "cp") (re.union (str.to_re "username") (str.to_re "password") (str.to_re "domain")))) (str.to_re "=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "'") (str.to_re "%27")) (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "$(") (str.to_re "%3b") (str.to_re "%60") (str.to_re "%24%28") (str.to_re ";") (str.to_re "`")) (str.to_re "/Pmi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
