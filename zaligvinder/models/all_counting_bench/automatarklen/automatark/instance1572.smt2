(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; YAHOODesktopHost\u{3a}LOGHost\x3AtvshowticketsResultsFROM\x3A
(assert (not (str.in_re X (str.to_re "YAHOODesktopHost:LOGHost:tvshowticketsResultsFROM:\u{0a}"))))
; ^(([0]?[1-9]|[1][0-2])[\/|\-|\.]([0-2]\d|[3][0-1]|[1-9])[\/|\-|\.]([2][0])?\d{2}\s+((([0][0-9]|[1][0-2]|[0-9])[\:|\-|\.]([0-5]\d)\s*([aApP][mM])?)|(([0-1][0-9]|[2][0-3]|[0-9])[\:|\-|\.]([0-5]\d))))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re "/") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1")) (re.range "1" "9")) (re.union (str.to_re "/") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.opt (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")))) (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.range "0" "5") (re.range "0" "9"))))))
; protocolNetControl\x2EServerKEYLOGGERUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "protocolNetControl.Server\u{13}KEYLOGGERUser-Agent:\u{0a}"))))
; act=\s+User-Agent\x3AEvilFTPHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "act=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:EvilFTPHost:\u{0a}")))))
; e2give\.comConnectionSpywww\x2Eslinkyslate
(assert (str.in_re X (str.to_re "e2give.comConnectionSpywww.slinkyslate\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)