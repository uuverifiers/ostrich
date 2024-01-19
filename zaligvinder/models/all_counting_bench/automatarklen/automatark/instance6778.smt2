(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((Ctrl\+Shift\+Alt\+|Ctrl\+Shift\+|Ctrl\+Alt\+|Shift\+Alt\+|Ctrl\+|Alt\+){1}(F1[0-2]|F[1-9]|[A-Za-z0-9\-\=\[\]\\\;\'\,\.\/]){1}){1}|(Shift\+)?(F1[0-2]|F[1-9]){1})$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.++ ((_ re.loop 1 1) (re.union (str.to_re "Ctrl+Shift+Alt+") (str.to_re "Ctrl+Shift+") (str.to_re "Ctrl+Alt+") (str.to_re "Shift+Alt+") (str.to_re "Ctrl+") (str.to_re "Alt+"))) ((_ re.loop 1 1) (re.union (re.++ (str.to_re "F1") (re.range "0" "2")) (re.++ (str.to_re "F") (re.range "1" "9")) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "=") (str.to_re "[") (str.to_re "]") (str.to_re "\u{5c}") (str.to_re ";") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "/"))))) (re.++ (re.opt (str.to_re "Shift+")) ((_ re.loop 1 1) (re.++ (str.to_re "F") (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9")))))) (str.to_re "\u{0a}"))))
; Cookie\u{3a}\s+\x2FGRSI\|Server\|Host\x3Aorigin\x3Dsidefind
(assert (str.in_re X (re.++ (str.to_re "Cookie:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/GRSI|Server|\u{13}Host:origin=sidefind\u{0a}"))))
; Host\x3A\u{25}2EResultsUser-Agent\x3A
(assert (str.in_re X (str.to_re "Host:%2EResultsUser-Agent:\u{0a}")))
; /filename=[^\n]*\u{2e}wmf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wmf/i\u{0a}"))))
; /filename=[^\n]*\u{2e}avi/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".avi/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
