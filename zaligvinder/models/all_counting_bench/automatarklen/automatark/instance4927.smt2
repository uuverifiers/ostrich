(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 714|760|949|619|909|951|818|310|323|213|323|562|626-\d{3}-\d{4}
(assert (not (str.in_re X (re.union (str.to_re "714") (str.to_re "760") (str.to_re "949") (str.to_re "619") (str.to_re "909") (str.to_re "951") (str.to_re "818") (str.to_re "310") (str.to_re "323") (str.to_re "213") (str.to_re "323") (str.to_re "562") (re.++ (str.to_re "626-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ^0$|^[1-9][0-9]*$|^[1-9][0-9]{0,2}(,[0-9]{3})$
(assert (not (str.in_re X (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a},") ((_ re.loop 3 3) (re.range "0" "9")))))))
; User-Agent\x3A.*Host\u{3a}\s+www\x2Ewordiq\x2Ecom\s+Subject\x3AAlexaOnline\u{25}21\u{25}21\u{25}21
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.wordiq.com\u{1b}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Subject:AlexaOnline%21%21%21\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
