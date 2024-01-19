(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d{1,})$|^(\d{1,}\.)$|^(\d{0,}?\.\d{1,})$|^([+-]\d{1,}(\.)?)$|^([+-](\d{1,})?\.\d{1,})$
(assert (not (str.in_re X (re.union (re.+ (re.range "0" "9")) (re.++ (re.+ (re.range "0" "9")) (str.to_re ".")) (re.++ (re.* (re.range "0" "9")) (str.to_re ".") (re.+ (re.range "0" "9"))) (re.++ (re.union (str.to_re "+") (str.to_re "-")) (re.+ (re.range "0" "9")) (re.opt (str.to_re "."))) (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "+") (str.to_re "-")) (re.opt (re.+ (re.range "0" "9"))) (str.to_re ".") (re.+ (re.range "0" "9")))))))
; Netspy\s\x3Aauto\x2Eisearch\x2EcomUser-Agent\x3Aaohobygi\u{2f}zwiwHWAEfhfksjzsfu\u{2f}ahm\.uqs
(assert (not (str.in_re X (re.++ (str.to_re "Netspy") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ":auto.isearch.comUser-Agent:aohobygi/zwiwHWAEfhfksjzsfu/ahm.uqs\u{0a}")))))
; ['`~!@#&$%^&*()-_=+{}|?><,.:;{}\"\\/\\[\\]]
(assert (not (str.in_re X (re.++ (re.union (str.to_re "'") (str.to_re "`") (str.to_re "~") (str.to_re "!") (str.to_re "@") (str.to_re "#") (str.to_re "&") (str.to_re "$") (str.to_re "%") (str.to_re "^") (str.to_re "*") (str.to_re "(") (re.range ")" "_") (str.to_re "=") (str.to_re "+") (str.to_re "{") (str.to_re "}") (str.to_re "|") (str.to_re "?") (str.to_re ">") (str.to_re "<") (str.to_re ",") (str.to_re ".") (str.to_re ":") (str.to_re ";") (str.to_re "\u{22}") (str.to_re "\u{5c}") (str.to_re "/") (str.to_re "[")) (str.to_re "]\u{0a}")))))
; ^((\+989)|(989)|(00989)|(09|9))([1|2|3][0-9]\d{7}$)
(assert (str.in_re X (re.++ (re.union (str.to_re "+989") (str.to_re "989") (str.to_re "00989") (str.to_re "09") (str.to_re "9")) (str.to_re "\u{0a}") (re.union (str.to_re "1") (str.to_re "|") (str.to_re "2") (str.to_re "3")) (re.range "0" "9") ((_ re.loop 7 7) (re.range "0" "9")))))
; User-Agent\x3AFiltered
(assert (str.in_re X (str.to_re "User-Agent:Filtered\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
