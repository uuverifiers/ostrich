(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CUSTOM\swww\x2Elocators\x2Ecom\d+Seconds\-
(assert (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.com") (re.+ (re.range "0" "9")) (str.to_re "Seconds-\u{0a}"))))
; /^([a-zA-Z0-9])(([\-.]|[_]+)?([a-zA-Z0-9]+))*(@){1}[a-z0-9]+[.]{1}(([a-z]{2,3})|([a-z]{2,3}[.]{1}[a-z]{2,3}))$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (re.+ (str.to_re "_")) (str.to_re "-") (str.to_re "."))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) ((_ re.loop 1 1) (str.to_re "@")) (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) ((_ re.loop 1 1) (str.to_re ".")) (re.union ((_ re.loop 2 3) (re.range "a" "z")) (re.++ ((_ re.loop 2 3) (re.range "a" "z")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 3) (re.range "a" "z")))) (str.to_re "/\u{0a}"))))
; Subject\x3A\swww\x2Esearchwords\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.searchwords.com\u{0a}")))))
; ^[a-zA-Z0-9]+(([_][a-zA-Z0-9])?[a-zA-Z0-9]*)*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (re.opt (re.++ (str.to_re "_") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; zopabora\x2EinfocomhoroscopeTravelInsidefromUser-Agent\x3AFrom\x3Awww\x2EZSearchResults\x2EcomExplorer
(assert (str.in_re X (str.to_re "zopabora.infocomhoroscopeTravelInsidefromUser-Agent:From:www.ZSearchResults.com\u{13}Explorer\u{0a}")))
(check-sat)
