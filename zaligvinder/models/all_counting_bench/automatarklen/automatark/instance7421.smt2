(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^&]*?(\u{2e}|%2e){2}([\u{2f}\u{5c}]|%2f|%5c)/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "&"))) ((_ re.loop 2 2) (re.union (str.to_re ".") (str.to_re "%2e"))) (re.union (str.to_re "%2f") (str.to_re "%5c") (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "/Pi\u{0a}")))))
; (^3[47])((\d{11}$)|(\d{13}$))
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 13) (re.range "0" "9"))) (str.to_re "\u{0a}3") (re.union (str.to_re "4") (str.to_re "7"))))))
; /^\/lists\/\d{20}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//lists/") ((_ re.loop 20 20) (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
; DISK\s+\x2Fcgi\x2Flogurl\.cgiSubject\x3AinsertX-Mailer\x3A
(assert (str.in_re X (re.++ (str.to_re "DISK") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cgi/logurl.cgiSubject:insertX-Mailer:\u{13}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
