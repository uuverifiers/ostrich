(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^(8-?|\+?7-?)?(\(?\d{3}\)?)-?(\d-?){6}\d$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (re.++ (str.to_re "8") (re.opt (str.to_re "-"))) (re.++ (re.opt (str.to_re "+")) (str.to_re "7") (re.opt (str.to_re "-"))))) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.++ (re.range "0" "9") (re.opt (str.to_re "-")))) (re.range "0" "9") (str.to_re "/\u{0a}") (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")))))
; www\x2Ealtnet\x2Ecom[^\n\r]*Host\x3A
(assert (str.in_re X (re.++ (str.to_re "www.altnet.com\u{1b}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:\u{0a}"))))
; for[^\n\r]*Host\x3A\sinternalcyber@yahoo\x2EcomHeadersRedirection
(assert (str.in_re X (re.++ (str.to_re "for") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "internalcyber@yahoo.comHeadersRedirection\u{0a}"))))
; Days\s+HWAE\s+Host\x3APortawww\.thecommunicator\.net
(assert (str.in_re X (re.++ (str.to_re "Days") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "HWAE") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Portawww.thecommunicator.net\u{0a}"))))
; /\r\nHost\u{3a}\u{20}[a-z0-9\u{2d}\u{2e}]+\.com\u{2d}[a-z0-9\u{2d}\u{2e}]+(\u{3a}\d{1,5})?\r\n/Hi
(assert (str.in_re X (re.++ (str.to_re "/\u{0d}\u{0a}Host: ") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (str.to_re ".com-") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "."))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")))) (str.to_re "\u{0d}\u{0a}/Hi\u{0a}"))))
(check-sat)
