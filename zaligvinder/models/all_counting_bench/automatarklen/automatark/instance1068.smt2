(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(30)[0-5]\d{11}$)|(^(36)\d{12}$)|(^(38[0-8])\d{11}$)
(assert (str.in_re X (re.union (re.++ (str.to_re "30") (re.range "0" "5") ((_ re.loop 11 11) (re.range "0" "9"))) (re.++ (str.to_re "36") ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "38") (re.range "0" "8")))))
; FreeAccessBar\s+hostie[^\n\r]*CodeguruBrowser\dStableWeb-MailUser-Agent\x3A195\.225\.Subject\x3A
(assert (not (str.in_re X (re.++ (str.to_re "FreeAccessBar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hostie") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "CodeguruBrowser") (re.range "0" "9") (str.to_re "StableWeb-MailUser-Agent:195.225.Subject:\u{0a}")))))
; /filename=[^\n]*\u{2e}k3g/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".k3g/i\u{0a}"))))
; /\u{2e}spx([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.spx") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; \(([0-9]{2}|0{1}((x|[0-9]){2}[0-9]{2}))\)\s*[0-9]{3,4}[- ]*[0-9]{4}
(assert (str.in_re X (re.++ (str.to_re "(") (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 2 2) (re.union (str.to_re "x") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re ")") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 4) (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
