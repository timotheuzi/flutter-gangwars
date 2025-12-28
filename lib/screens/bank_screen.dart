import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank - Droid Gangwar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => gameProvider.navigateToScreen('city'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.deepPurple.shade600,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Text(
                        '🏦 BANK',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Money', '\$${gameState.money}', Colors.green),
                          _buildStatItem('Account', '\$${gameState.account}', Colors.blue),
                          _buildStatItem('Loan', '\$${gameState.loan}', Colors.red),
                        ],
                      ),
                      if (gameState.loan > 0) ...[
                        const SizedBox(height: 5),
                        Text(
                          'Loan Status: ${gameState.flags.hasAttractedLoanShark ? "HUNTED BY LOAN SHARKS" : "Due soon"}',
                          style: TextStyle(
                            color: gameState.flags.hasAttractedLoanShark ? Colors.red : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    _buildBankActionCard(
                      context,
                      'Deposit Money',
                      'Move cash to your account.',
                      Colors.green,
                      () => _showDepositDialog(context),
                    ),
                    const SizedBox(height: 8),
                    _buildBankActionCard(
                      context,
                      'Withdraw Money',
                      'Take cash from your account.',
                      Colors.blue,
                      () => _showWithdrawDialog(context),
                    ),
                    const SizedBox(height: 8),
                    _buildBankActionCard(
                      context,
                      'Take Loan',
                      'Borrow cash. Pay back in 1 day!',
                      Colors.orange,
                      () => _showLoanDialog(context),
                    ),
                    const SizedBox(height: 8),
                    _buildBankActionCard(
                      context,
                      'Repay Loan',
                      'Clear your debt before they find you.',
                      Colors.red,
                      gameState.loan > 0 ? () => _showRepayDialog(context) : null,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GameButton(
                  text: 'Return to City',
                  onPressed: () => gameProvider.navigateToScreen('city'),
                  icon: Icons.arrow_back,
                  backgroundColor: Colors.brown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildBankActionCard(BuildContext context, String title, String description, Color color, VoidCallback? onPressed) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet, color: color),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deposit Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available cash: \$${gameProvider.gameState.money}'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to deposit',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameProvider.gameState.money) {
                gameProvider.gameState.money -= amount;
                gameProvider.gameState.account += amount;
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deposited \$${amount.toString()}')),
                );
              }
            },
            child: const Text('Deposit'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bank account: \$${gameProvider.gameState.account}'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to withdraw',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameProvider.gameState.account) {
                gameProvider.gameState.money += amount;
                gameProvider.gameState.account -= amount;
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Withdrew \$${amount.toString()}')),
                );
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  void _showLoanDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController(text: '1000');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Take Loan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Warning: Loans must be repaid in 1 day or you will be hunted!'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Loan amount',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                gameProvider.gameState.money += amount;
                gameProvider.gameState.loan += amount;
                gameProvider.gameState.loanDayTaken = gameProvider.gameState.day;
                gameProvider.gameState.flags.hasAttractedLoanShark = false;
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Took loan of \$${amount.toString()} - repay it FAST!')),
                );
              }
            },
            child: const Text('Take Loan'),
          ),
        ],
      ),
    );
  }

  void _showRepayDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Repay Loan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current loan: \$${gameProvider.gameState.loan}'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to repay',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameProvider.gameState.money) {
                gameProvider.gameState.money -= amount;
                gameProvider.gameState.loan -= amount;
                if (gameProvider.gameState.loan <= 0) {
                  gameProvider.gameState.loan = 0;
                  gameProvider.gameState.flags.hasAttractedLoanShark = false;
                }
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Repaid \$${amount.toString()} on your loan')),
                );
              }
            },
            child: const Text('Repay'),
          ),
        ],
      ),
    );
  }
}
