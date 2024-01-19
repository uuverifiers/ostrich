(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}m3u/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m3u/i\u{0a}"))))
; /(^|&)filename=[^&]*?(\u{2e}|%2e){2}([\u{2f}\u{5c}]|%2f|%5c)/Pmi
(assert (str.in_re X (re.++ (str.to_re "/&filename=") (re.* (re.comp (str.to_re "&"))) ((_ re.loop 2 2) (re.union (str.to_re ".") (str.to_re "%2e"))) (re.union (str.to_re "%2f") (str.to_re "%5c") (str.to_re "/") (str.to_re "\u{5c}")) (str.to_re "/Pmi\u{0a}"))))
; (^(6011)\d{12}$)|(^(65)\d{14}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "6011") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}65") ((_ re.loop 14 14) (re.range "0" "9"))))))
; Host\x3A\swww\x2Etopadwarereviews\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.topadwarereviews.com\u{0a}")))))
; /^\/[a-f0-9]{32}\.eot$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".eot/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
