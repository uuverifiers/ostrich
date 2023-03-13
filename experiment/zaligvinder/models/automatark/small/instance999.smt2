(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \sKeylogging\s+ApofisToolbar
(assert (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Keylogging\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ApofisToolbar\u{0a}"))))
; ^\d{5}((-|\s)?\d{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}xcf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xcf/i\u{0a}")))))
; adfsgecoiwnf\d+Host\u{3a}TCP\x2FAD\x2FULOGNetBus
(assert (str.in_re X (re.++ (str.to_re "adfsgecoiwnf\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Host:TCP/AD/ULOGNetBus\u{0a}"))))
; wowokay\d+FTP\s+Host\x3AFiltered\u{22}reaction\x2Etxt\u{22}
(assert (str.in_re X (re.++ (str.to_re "wowokay") (re.+ (re.range "0" "9")) (str.to_re "FTP") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Filtered\u{22}reaction.txt\u{22}\u{0a}"))))
(check-sat)
