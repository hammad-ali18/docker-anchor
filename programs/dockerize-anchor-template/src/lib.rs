pub mod constants;
pub mod error;
pub mod instructions;
pub mod state;

use anchor_lang::prelude::*;

pub use constants::*;
pub use instructions::*;
pub use state::*;

declare_id!("CrkBbzYtVBeSVJsUrWHfCZTCpGv6jW52bDzeVvfd3cmE");

#[program]
pub mod dockerize_anchor_template {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        initialize::handler(ctx)
    }
}
