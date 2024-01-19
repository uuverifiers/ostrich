(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\.take5bingo\.com\d+Host\x3AHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.take5bingo.com\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "Host:Host:\u{0a}")))))
; /\u{0a}Array\u{0a}\u{28}\u{0a}\u{20}{4}\u{5b}[a-z\d]{11}\u{5d}\u{20}\u{3d}\u{3e}\u{20}\d{16}\u{0a}\u{29}/i
(assert (not (str.in_re X (re.++ (str.to_re "/\u{0a}Array\u{0a}(\u{0a}") ((_ re.loop 4 4) (str.to_re " ")) (str.to_re "[") ((_ re.loop 11 11) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "] => ") ((_ re.loop 16 16) (re.range "0" "9")) (str.to_re "\u{0a})/i\u{0a}")))))
; ^(([0-2])?([0-9]))$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.range "0" "2")) (re.range "0" "9")))))
; /filename=[^\n]*\u{2e}wal/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wal/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
