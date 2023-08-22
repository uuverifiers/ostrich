(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-\w\s"'=/!@#%&,;:`~\.\$\^\{\[\(\|\)\]\}\*\+\?\\]*$
(assert (not (str.in_re X (re.++ (re.* (re.union (str.to_re "-") (str.to_re "\u{22}") (str.to_re "'") (str.to_re "=") (str.to_re "/") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "%") (str.to_re "&") (str.to_re ",") (str.to_re ";") (str.to_re ":") (str.to_re "`") (str.to_re "~") (str.to_re ".") (str.to_re "$") (str.to_re "^") (str.to_re "{") (str.to_re "[") (str.to_re "(") (str.to_re "|") (str.to_re ")") (str.to_re "]") (str.to_re "}") (str.to_re "*") (str.to_re "+") (str.to_re "?") (str.to_re "\u{5c}") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; (([01][\.\- +]\(\d{3}\)[\.\- +]?)|([01][\.\- +]\d{3}[\.\- +])|(\(\d{3}\) ?)|(\d{3}[- \.]))?\d{3}[- \.]\d{4}
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "+")) (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "+")))) (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "+")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "+"))) (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re ".")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}lnk/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".lnk/i\u{0a}")))))
; configINTERNAL\.ini\s+User-Agent\x3A\s+Host\x3ASubject\u{3a}
(assert (str.in_re X (re.++ (str.to_re "configINTERNAL.ini") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Subject:\u{0a}"))))
; now\d+\x2Fbar_pl\x2Fshdoclc\.fcgiareHost\x3Ae2give\.com
(assert (not (str.in_re X (re.++ (str.to_re "now") (re.+ (re.range "0" "9")) (str.to_re "/bar_pl/shdoclc.fcgiareHost:e2give.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
