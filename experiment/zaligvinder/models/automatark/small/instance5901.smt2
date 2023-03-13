(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}m3u/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m3u/i\u{0a}"))))
; /setInterval\s*\u{28}[^\u{29}]+\u{2e}focus\u{28}\u{29}/smi
(assert (str.in_re X (re.++ (str.to_re "/setInterval") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(") (re.+ (re.comp (str.to_re ")"))) (str.to_re ".focus()/smi\u{0a}"))))
; \x2Fbonzibuddy\x2Forigin\x3DsidefindApofisUser-Agent\x3A
(assert (str.in_re X (str.to_re "/bonzibuddy/origin=sidefindApofisUser-Agent:\u{0a}")))
; Agent.*as\x2Estarware\x2Ecom\s+ServerToolbarcojud\x2Edmcast\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Agent") (re.* re.allchar) (str.to_re "as.starware.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ServerToolbarcojud.dmcast.com\u{0a}")))))
; ^(\d)?[ ]*[\(\.\-]?(\d{3})[\)\.\-]?[ ]*(\d{3})[\.\- ]?(\d{4})[ ]*(x|ext\.?)?[ ]*(\d{1,7})?$
(assert (not (str.in_re X (re.++ (re.opt (re.range "0" "9")) (re.* (str.to_re " ")) (re.opt (re.union (str.to_re "(") (str.to_re ".") (str.to_re "-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ")") (str.to_re ".") (str.to_re "-"))) (re.* (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.* (str.to_re " ")) (re.opt (re.union (str.to_re "x") (re.++ (str.to_re "ext") (re.opt (str.to_re "."))))) (re.* (str.to_re " ")) (re.opt ((_ re.loop 1 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
