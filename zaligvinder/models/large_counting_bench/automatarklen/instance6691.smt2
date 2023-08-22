(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,8}[a-zA-Z0-9]$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) ((_ re.loop 2 8) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re "."))) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\x3AFrom\x3Awww\x2Eonlinecasinoextra\x2EcomHost\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:From:www.onlinecasinoextra.comHost:\u{0a}"))))
; /nim:import\?[^\u{22}\u{27}>\s]*?filename=[^\u{22}\u{27}>\s]{485}/i
(assert (str.in_re X (re.++ (str.to_re "/nim:import?") (re.* (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "filename=") ((_ re.loop 485 485) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ">") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/i\u{0a}"))))
; /filename=[^\n]*\u{2e}wal/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wal/i\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
